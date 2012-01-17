module WordsHelper
  def check_foreign
    session[:filter] == 'foreign'
  end
  
  def check_native
    session[:filter] == 'native'
  end
  
  def nocheck
    session[:filter] == nil
  end
end
