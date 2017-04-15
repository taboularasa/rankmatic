module Rankmatic
  class Submission
    def initialize(id:, scores: [])
      @id = id
      @scores = scores
    end

    def id
      @id
    end

    def total
      @scores.reduce(:+)
    end

    def average
      total / score_count
    end

    def score_count
      @scores.length
    end
  end
end
