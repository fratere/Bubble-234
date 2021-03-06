class ReviewsController < ApplicationController

    before_action :authenticate_user! && :find_cocktail, except: :show

    def find_cocktail
        unless (@cocktail = Cocktail.find_by(:id => params[:cocktail_id]))
        end
    end

    def edit
      begin
        @review = Review.find params[:id]
      rescue ActiveRecord::RecordNotFound => e
        redirect_to root_path, flash: {:alert => 'No review found'}
      end
    end

    def update
        begin
            @review = Review.find params[:id]
            @review.update_attributes!(review_params)
            flash[:notice] = "Your review was successfully updated"
            redirect_to cocktail_review_path(@review.id)
        rescue ActiveRecord::RecordNotFound => e
          redirect_to root_path, flash: {:alert => 'No review found'}
        end
      end

    def show
        begin
            @review = Review.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          redirect_to root_path, flash: {:alert => 'No review found'}
        end
    end

    def new
        @review = @cocktail.reviews.build
    end

    def create
        @review = @cocktail.reviews.build(review_params)
        current_user.reviews << @review
        if @review.save
            redirect_to cocktail_review_path(:id => @review.id, :cocktail_id => @cocktail.id)
        else
            render 'new'
        end
    end

    def review_params
        params.require(:review).permit(:rate, :comments)
    end

    def destroy
        begin
            @review = @cocktail.reviews.find(params[:id])
            @review.destroy
            flash[:notice] = "#{@review.user.username}'s Review deleted"
            redirect_to cocktail_path(@cocktail)
        rescue ActiveRecord::RecordNotFound => e
            redirect_to root_path, flash: {:alert => 'No review found'}
        end
    end

    def like
        @review = Review.find (params[:id])
        #if !current_user.reviews_liked.include? @review
        current_user.reviews_liked << @review
        #end
        redirect_to cocktail_review_path(@review)
    end

    def dislike
        @review = Review.find params[:id]
        current_user.reviews_liked.destroy(@review)
        redirect_to cocktail_review_path(@review)
    end

    def cocktail_params
        params.require(:review).permit(:id, :rate, :comments)
    end

end
