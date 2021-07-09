class Book < ApplicationRecord
	
	belongs_to :user
	
	# dependent: :destroy 親モデルを削除する際に、その親モデルに紐づく「子モデル」も一緒に削除できる
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy
	
	validates :rate, presence: true
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
	
  # favorited_by?メソッド 
  # 引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べます。
  # 存在していればtrue、存在していなければfalseを返すようにしています。
	def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  def self.looks(search, word)
    if search == "perfect"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward"
      @book = Book.where("title LIKE?","%#{word}")
    else search == "partia"
      @book = Book.where("title LIKE?","%#{word}%")
    end
  end
	
end
