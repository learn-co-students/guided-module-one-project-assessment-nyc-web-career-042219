class User < ActiveRecord::Base

  has_many :lists
  has_many :movies, through: :lists

 def get_movie_id_from_list
   movie_list_id = self.lists.map do |movie_list|
     movie_list.movie_id
   end
 end

 def get_movie_objects
   ids = get_movie_id_from_list
    movie_objects = ids.map do |id|
      Movie.all.find(id)
    end
 end

 
 #----------------------------------for genre
  def get_genres_from_movie_objects
    get_movie_objects.map do |object|
      object.genre
    end.join(', ')
  end

  def find_most_popular_genre
    genre = get_genres_from_movie_objects.split(',')
    genre.group_by do |genre|
      genre
    end.values.max_by(&:size).first
  end
#-------------------------------------------

end
