class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  before_validation :strip_white_space

  belongs_to :commentable, :polymorphic => true
  validates :comment, length: { minimum: 2 }

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  def strip_white_space
    self.comment = comment.strip if attribute_present?("comment")
  end
end
