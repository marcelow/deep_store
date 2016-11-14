require 'spec_helper'

RSpec.describe DeepStore::DAO do
  class MockCodec
    include DeepStore::Codecs::Codec
  end

  let(:instance) { described_class.new(adapter: adapter, bucket: bucket, codec: codec) }

  let(:adapter) { instance_double(Aws::S3::Client) }
  let(:bucket) { 'test-bucket' }
  let(:codec) { MockCodec.new }

  describe '#head' do
    subject { instance.head(key) }

    let(:key) { 'KEY' }
    let(:metadata) { double }

    context 'when the request succeeds' do
      before do
        allow(adapter).to receive(:head_object).and_return(metadata)
      end

      it { is_expected.to eq(metadata) }

      it "executes a 'HEAD OBJECT' request" do
        expect(adapter).to receive(:head_object).with(bucket: bucket, key: key)
        subject
      end
    end

    context 'when the request fails' do
      let(:external_error) { Aws::S3::Errors::NoSuchKey.new(nil, nil) }

      before do
        allow(adapter).to receive(:head_object).and_raise(external_error)
      end

      it { expect { subject }.to raise_error(DeepStore::Errors::RecordNotFound) }
    end
  end

  describe '#get' do
    subject { instance.get(key) }

    let(:key) { 'KEY' }
    let(:stream) { instance_double(Tempfile) }

    before do
      allow(Tempfile).to receive(:new).and_return(stream)
      allow(stream).to receive(:binmode)
    end

    context 'when the request succeeds' do
      let(:object) { double }
      let(:decoded_stream) { double }
      let(:result) { DeepStore::DAO::Result.new(object: object, stream: decoded_stream) }

      before do
        allow(codec).to receive(:decode).and_return(decoded_stream)
        allow(adapter).to receive(:get_object).and_return(object)
      end

      it { is_expected.to eq(result) }

      it 'sets the accept stream to binary mode' do
        expect(stream).to receive(:binmode)
        subject
      end

      it "executes a 'GET OBJECT' request" do
        expect(adapter).to receive(:get_object)
          .with(bucket: bucket, key: key, response_target: stream)

        subject
      end
    end

    context 'when the request fails' do
      let(:external_error) { Aws::S3::Errors::NoSuchKey.new(nil, nil) }

      before do
        allow(adapter).to receive(:get_object).and_raise(external_error)
      end

      it { expect { subject }.to raise_error(DeepStore::Errors::RecordNotFound) }
    end
  end

  describe '#put' do
    subject { instance.put(key, stream) }

    let(:key) { 'KEY' }
    let(:stream) { instance_double(Tempfile) }
    let(:encoded_stream) { instance_double(Tempfile) }

    before do
      allow(codec).to receive(:encode).and_return(encoded_stream)
      allow(adapter).to receive(:put_object).and_return(true)
    end

    it { is_expected.not_to be_nil }

    it "executes a 'PUT OBJECT' request" do
      expect(adapter).to receive(:put_object)
        .with(bucket: bucket, key: key, body: encoded_stream)

      subject
    end
  end

  describe '#delete' do
    subject { instance.delete(key) }

    let(:key) { 'KEY' }

    before do
      allow(adapter).to receive(:delete_object).and_return(true)
    end

    it { is_expected.not_to be_nil }

    it "executes a 'DELETE OBJECT' request" do
      expect(adapter).to receive(:delete_object)
        .with(bucket: bucket, key: key)

      subject
    end
  end

  describe '#expand_path' do
    subject { instance.expand_path(path) }

    let(:path) { 'path' }
    let(:collection) { double(contents: contents) }
    let(:contents) { Array.new(3) { |i| double(key: "path/#{i}") } }
    let(:empty_collection) { double(contents: []) }

    before do
      allow(adapter).to receive(:list_objects) do |**args|
        case args[:marker]
        when nil
          collection
        when 'path/2'
          empty_collection
        end
      end
    end

    it { is_expected.to eq(%w(path/0 path/1 path/2)) }

    it "executes a 'LIST OBJECT' request with an empty marker" do
      expect(adapter).to receive(:list_objects)
        .with(bucket: bucket, prefix: 'path', marker: nil, max_keys: 50)
        .once

      subject
    end

    it "executes a 'LIST OBJECT' request with the second marker" do
      expect(adapter).to receive(:list_objects)
        .with(bucket: bucket, prefix: 'path', marker: 'path/2', max_keys: 50)
        .once

      subject
    end
  end
end
