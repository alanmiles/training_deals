class AdminPagesController < ApplicationController

    before_action :not_admin
    
    def framework
    end

    def users_menu
    end

    def vendors_menu
    end

    def feedback
    end

    def billings
    end

    def text_editor
    end


end
