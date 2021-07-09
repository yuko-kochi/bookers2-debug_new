class NewarrivalsController < ApplicationController

def newarrivals
  @book = Book.order(created_at: :desc)
end

end
