class RecipesController < ApplicationController
    
    def index
        user = User.find_by(id: session[:user_id])
        if user
            recipes = Recipe.all
            render json: recipes, each_serializer: RecipeSerializer, status: :created
        else
            render json: { errors: ["Not Logged In"] }, status: :unauthorized
        end
    end

    def create
        target_user = User.find_by(id: session[:user_id])
        if target_user
            recipe = target_user.recipes.create(recipe_params)
            if recipe.save
                render json: { recipe: recipe }, status: :created
            else
                render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { errors: ["Not Logged In"] }, status: :unauthorized
        end
    end

    private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

end
