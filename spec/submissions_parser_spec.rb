require 'spec_helper'

RSpec.describe Rankmatic::SubmissionsParser do

  let(:example_csv) do
    example_content =
<<-eos
email,total
foo@example.com,42
bar@example.com,100
foo@example.com,10
eos
    Tempfile.new('example_csv').tap do |csv|
      csv.write(example_content)
      csv.close
    end
  end

  let(:csv_path) { example_csv.path }

  after(:each) do
    example_csv.unlink
  end

  describe '#new' do
    it 'requires the key to group by' do
      expect { Rankmatic::SubmissionsParser.new(rank_by:'',csv_path:'') }
        .to raise_error('missing keyword: group_by')
    end

    it 'requires the key to rank by' do
      expect { Rankmatic::SubmissionsParser.new(group_by:'', csv_path:'') }
        .to raise_error('missing keyword: rank_by')
    end

    it 'requires the path to a csv' do
      expect { Rankmatic::SubmissionsParser.new(group_by:'', rank_by:'') }
        .to raise_error('missing keyword: csv_path')
    end

    it 'fails fast with a bad csv' do
      bad_init = lambda do
        Rankmatic::SubmissionsParser.new(group_by:'',
                              rank_by:'',
                              csv_path: 'spec/spec_helper.rb')
      end
      expect(&bad_init).to raise_error(CSV::MalformedCSVError)

      good_init = lambda do
        Rankmatic::SubmissionsParser.new(group_by:'',
                              rank_by:'',
                              csv_path: csv_path)
      end
      expect(&good_init).to_not raise_error
    end
  end

  describe '#submissions' do
    it 'returns a collection of submissions with unique keys' do
      subject = Rankmatic::SubmissionsParser.new(group_by: 'email',
                                      rank_by:'total',
                                      csv_path: csv_path)


      expect(subject.submissions.count).to eq(2)
      expect(subject.submissions.all? {|s| s.is_a? Rankmatic::Submission })
        .to eq(true)
    end

    it 'aggregates scores correctly' do
      subject = Rankmatic::SubmissionsParser.new(group_by: 'email',
                                      rank_by:'total',
                                      csv_path: csv_path)

      foo = subject.submissions.detect {|s| s.id == 'foo@example.com' }
      expect(foo.scores).to include(42, 10)

      bar = subject.submissions.detect {|s| s.id == 'bar@example.com' }
      expect(bar.scores).to eq([100])
    end

  end

  describe '#build_submission' do
    it 'builds a Submission correctly' do
      subject = Rankmatic::SubmissionsParser.new(
        group_by:'email',
        rank_by:'total',
        csv_path: csv_path)

      result = subject.build_submission('foo@example.com')

      expect(result.id).to eq('foo@example.com')
      expect(result.scores).to include(42, 10)
    end
  end
end
