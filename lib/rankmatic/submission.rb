module Rankmatic
  class Submission
    attr_reader :scores, :id

    def initialize(id:, scores: [])
      @id = id
      @scores = scores
    end

    def total
      scores.reduce(:+)
    end

    def average
      total / score_count
    end

    def score_count
      scores.length
    end
  end
end
