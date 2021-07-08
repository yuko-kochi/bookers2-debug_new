class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # dependent: :destroy 親モデルを削除する際に、その親モデルに紐づく「子モデル」も一緒に削除できる
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :book
  has_many :book_comments, dependent: :destroy
  
  attachment :profile_image, destroy: false
  
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # 被フォロー関係を通じて参照→自分をフォローしている人
  # through（スルー）は、あるリレーションを他のテーブルを通して実現する際に用いる
  has_many :followers, through: :reverse_of_relationships, source: :follower
    # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  
  def follow(user_id)
    # createメソッドはnewとsaveを合わせた挙動。
    relationships.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    # relationshipsテーブルには対応するレコードはただ一つ。
    # そのためfind_byによって1レコードを特定し、destroyメソッドで削除する。
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    # include?は対象の配列に引数のものが含まれていればtrue、含まれていなければfalseを返す。
    followings.include?(user)
  end
  
  def self.looks(search, word)
    if search == "perfect"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward"
      @user = User.where("name LIKE?","%#{word}")
    else search == "partial"
      @user = User.where("name LIKE?","%#{word}%")
    end
  end
  
  
end
