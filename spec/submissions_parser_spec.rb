require 'spec_helper'

RSpec.describe Rankmatic::SubmissionsParser do
  let(:example_csv) do
    example_content =
<<-eos
email,friendly,smart,cool
foo@example.com,42,50,2
bar@example.com,50,200,150
foo@example.com,10,3,4
edgecase@example.com,51,0,0
eos
    Tempfile.new('example_csv').tap do |csv|
      csv.write(example_content)
      csv.close
    end
  end

  let(:csv_path) { example_csv.path }

  let(:subject) do
    args = { group_by:'email', csv_path: csv_path }
    Rankmatic::SubmissionsParser.new(args)
  end

  after(:each) do
    example_csv.unlink
  end

  describe '#new' do
    it 'requires the key to group by' do
      expect { Rankmatic::SubmissionsParser.new(rank_by:'',csv_path:'') }
        .to raise_error('missing keyword: group_by')
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
      expect(subject.submissions.count).to eq(3)
      expect(subject.submissions.all? {|s| s.is_a? Rankmatic::Submission })
        .to eq(true)
    end
  end

  describe '#build_submission' do
    it 'builds a Submission correctly' do
      result = subject.build_submission('foo@example.com')

      expect(result.id).to eq('foo@example.com')
      expect(result.scores).to contain_exactly(17, 94)
    end
  end

  describe '#rank' do
    it 'ranks the submissions by the averages of the specified column' do
      subject = Rankmatic::SubmissionsParser.new(
        group_by:'email',
        rank_by: 'friendly',
        csv_path: csv_path)

      expect(subject.rank.first).to eq('edgecase@example.com')
    end

    it 'ranks by suming all score columns when rank_by is omitted' do
      expect(subject.rank)
        .to eq(['bar@example.com', 'foo@example.com', 'edgecase@example.com'])
    end
  end
end
