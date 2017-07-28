class SessionsController < ApplicationController

  def new
  end

  def create
    u = User.find_by(username: params["username"])

    if u != nil
      if u.authenticate(params["password"])
        session["user_id"] = u.id
        redirect_to "/videos", notice: "Welcome back, #{u.name}!"
      else
        redirect_to "/sessions/new", alert: "Bad password"
      end
    else
      redirect_to "/sessions/new", alert: "Unknown user"
    end

  end

  def destroy
    reset_session
    redirect_to "/", notice: "See ya!"
  end

end
