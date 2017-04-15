require 'csv'

module Rankmatic
  class SubmissionsParser
    def initialize(group_by:, rank_by:, csv_path:)
      @group_by = group_by
      @rank_by = rank_by
      @rows = []
      CSV.foreach(csv_path, headers: true) { |r| @rows << r }
    end

    def submission_count
      @rows.length
    end

    def submissions
      @submissions ||= begin
        @rows.map {|r| r[@group_by] }.uniq.map do |id|
          scores = @rows.select {|r| r[@group_by] == id}
                        .map {|r| r[@rank_by].to_i }

          Submission.new(id: id, scores: scores)
        end
      end
    end
  end
end
