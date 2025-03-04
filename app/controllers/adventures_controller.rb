class AdventuresController < ApplicationController
  before_action :set_adventure, only: [:show, :edit, :update, :destroy, :picture]

  # GET /adventures
  # GET /adventures.json
  def index
    #@adventures = Adventure.all
    @adventures = Adventure.paginate(:page => params[:page], :per_page => 16)
  end
  # GET /adventures/1
  # GET /adventures/1.json
  def show
  end

  # GET /adventures/new
  def new
    @adventure = Adventure.new
    @adventure.image_from_url(params[:image_url])
  end

  # GET /adventures/1/edit
  def edit
  end

  # POST /adventures
  # POST /adventures.json
  def create
    @adventure = Adventure.new(adventure_params)
    @adventure.image_from_url(params[:image_url])
    respond_to do |format|
      if @adventure.save
        @adventure = multiple_photos(@adventure)
        format.html { redirect_to @adventure, notice: 'Adventure was successfully created.' }
        format.json { render :show, status: :created, location: @adventure }
      else
        format.html { render :new }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adventures/1
  # PATCH/PUT /adventures/1.json
  def update
    respond_to do |format|
      if @adventure.update(adventure_params)
        @adventure = multiple_photos(@adventure)

        format.html { redirect_to @adventure, notice: 'Adventure was successfully updated.' }
        format.json { render :show, status: :ok, location: @adventure }
      else
        format.html { render :edit }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adventures/1
  # DELETE /adventures/1.json
  def destroy
    @adventure.destroy
    respond_to do |format|
      format.html { redirect_to users_show_url, notice: 'Adventure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def profile_home
  end

  def search_adventures
   if !params[:adventure_title].nil?
     search_string = params[:adventure_title]
     @adventures = Adventure.basic_search({title: search_string, tags: search_string}, false)
     #@adventures = Adventure.where(search_string + " = ANY (tags")
     #@adventures = @adventures.paginate(:page => params[:page], :per_page => 12)
   end
  end

  def add_comment
    @adventure = Adventure.find(params[:id])
    comment = params[:comment]
    if !comment.blank? && @adventure.comments.blank?
      @adventure.comments = []
      @adventure.comments << comment
      @adventure.save
    elsif !comment.blank?
      @adventure.comments << comment
      @adventure.save
    end
    render "show.html.erb"
  end

  def add_tag
    @adventure = Adventure.find(params[:id])
    tag = params[:tag]
    if !tag.nil?
      @adventure.tags << tag
      @adventure.save
    end
    render "show.html.erb"
  end

  def get_random_adventure
      @adventure = Adventure.all.sample
    respond_to do |format|
      format.html { redirect_to adventures_url }
      format.json { render :show, status: :ok, location: @adventure }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adventure
      @adventure = Adventure.find(params[:id])
    end

    def multiple_photos(adventure)
      if params[:photos]
        params[:photos].each do |image|
          adventure.pictures.create(photo: image)
        end
      end
        return adventure
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adventure_params
      params.require(:adventure).permit(:title, :description, :duedate, :creator, :priority, :completed, :comments, :image, :photos, :tags)
    end
end
