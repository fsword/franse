class WordsController < InheritedResources::Base

  def create
    create! do |format|
      format.html { redirect_to new_word_url }
    end
  end

  def update
    update! do |format|
      format.html { redirect_to words_url }
    end
  end

  def archieve
    Word.find_each do |word| 
      word.archieve params[:cycle_num]
    end
    redirect_to words_url
  end

  protected
    def collection
      if params[:filter]=='none'
        session[:filter] = nil
      elsif params[:filter]
        session[:filter] = params[:filter]
      end
      if session[:filter]
        @words ||= Word.learn_by(session[:filter]).sort_by{rand}
      else
        @words ||= end_of_association_chain.all
      end
    end
end
