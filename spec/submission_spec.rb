require 'spec_helper'

RSpec.describe Rankmatic::Submission do
  let(:email) { 'foo@example.com' }

  describe '#id' do
    it 'returns the email as an id' do
      subject = Rankmatic::Submission.new(id: email)
      expect(subject.id).to eq(email)
    end
  end

  describe '#total' do
    it 'gives the sum of all the scores' do
      subject = Rankmatic::Submission.new(id: email, scores: [1, 2, 3, 6, 7, 9, 14])
      expect(subject.total).to eq(42)
    end
  end

  describe '#average' do
    it 'gives the average of all the scores' do
      subject = Rankmatic::Submission.new(id: email, scores: [1, 2, 3, 6, 7, 9, 14])
      expect(subject.average).to eq(6)
    end
  end

  describe '#score_count' do
    it 'gives the count of scores' do
      subject = Rankmatic::Submission.new(id: email, scores: [1, 2, 3, 6, 7, 9, 14])
      expect(subject.score_count).to eq(7)
    end
  end
end
