# coding: utf-8
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

  def testing
    word = Word.find params[:id]
    key,value = params[:word].flatten
    if word.send(key) == value
      word.update_attribute("can_#{key.split('_')[0]}", true)
    else
      flash[:notice] = "填写错误"
    end
    redirect_to words_url
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
