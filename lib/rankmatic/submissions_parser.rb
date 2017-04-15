require 'csv'

module Rankmatic
  class SubmissionsParser
    def initialize(group_by:, rank_by:, csv_path:)
      @group_by = group_by
      @rank_by = rank_by
      @rows = []
      CSV.foreach(csv_path, headers: true) { |r| @rows << r }
    end

    def submissions
      @submissions ||=
        @rows.map { |r| r[@group_by] }.uniq
             .map { |id| build_submission(id) }
    end

    def build_submission(id)
      score = ->(r) { r[@rank_by].to_i }
      scores = @rows.select { |r| r[@group_by] == id }.map(&score)
      Submission.new(id: id, scores: scores)
    end
  end
end
