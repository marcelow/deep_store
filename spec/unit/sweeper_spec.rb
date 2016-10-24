require 'spec_helper'

RSpec.describe DeepStore::Sweeper do
  describe '#call' do
    let(:instance) { described_class.new(stream) }

    subject { instance.call(_object_id) }

    let(:_object_id) { 123 }
    let(:stream) { instance_double(Tempfile) }

    before do
      allow(stream).to receive(:close)
      allow(stream).to receive(:unlink)
    end

    it 'closes the stream' do
      expect(stream).to receive(:close)
      subject
    end

    it 'unlinks the stream' do
      expect(stream).to receive(:unlink)
      subject
    end
  end
end
