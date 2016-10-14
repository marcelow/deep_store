require 'spec_helper'

RSpec.describe DeepStore::KeyParser do
  describe '.call' do
    subject { described_class.call(key, pattern) }

    let(:pattern) { ':dataset/:year/:month/:day/:filename' }
    let(:key) { 'events/2016/12/01/file-ABC.gz' }

    it { is_expected.to include(dataset: 'events') }
    it { is_expected.to include(year: '2016') }
    it { is_expected.to include(month: '12') }
    it { is_expected.to include(day: '01') }
    it { is_expected.to include(filename: 'file-ABC.gz') }
  end
end
