require 'csv'

module Rankmatic
  class SubmissionsParser
    def initialize(group_by:, rank_by: nil, csv_path:)
      @group_by = group_by
      @rank_by = rank_by
      @rows = []
      CSV.foreach(csv_path, headers: true) { |r| @rows << r.to_h }
    end

    def submissions
      @submissions ||=
        @rows.map { |r| r[@group_by] }.uniq
             .map { |id| build_submission(id) }
    end

    def build_submission(id)
      scores = @rows.select { |r| r[@group_by] == id }.map {|r| score(r) }
      Submission.new(id: id, scores: scores)
    end

    def score(row)
      return row[@rank_by].to_i if @rank_by
      row.delete_if { |k, _| k == @group_by }.values.map(&:to_i).reduce(&:+)
    end

    def rank
      submissions.sort_by(&:average).reverse.map(&:id)
    end
  end
end
