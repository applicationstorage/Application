class RegistrationsController < Devise::RegistrationsController

    def create
        super
        if @loans.save
            UserMailer.notify_user(@loan).deliver_now
        end
    end
    
end
