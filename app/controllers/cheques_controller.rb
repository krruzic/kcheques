require 'to_words'
require 'RMagick'

class ChequesController < ApplicationController
  before_action :set_cheque, only: [:show, :edit, :update, :destroy]

  # GET /cheques
  # GET /cheques.json
  def index
    @cheques = Cheque.all
    @cheques = Cheque.where(nil) # creates an anonymous scope
    @cheques = @cheques.person(params[:person]) if params[:person].present?
  end

  # GET /cheques/1
  # GET /cheques/1.json
  def show
  end

  # GET /cheques/new
  def new
    @cheque = Cheque.new
  end

  # GET /cheques/1/edit
  def edit
  end

  # POST /cheques
  # POST /cheques.json
  def create
    @cheque = Cheque.new(cheque_params)

    respond_to do |format|
      if @cheque.save
        create_cheque_image(@cheque)
        format.html { redirect_to @cheque, notice: 'Cheque was successfully created.' }
        format.json { render :show, status: :created, location: @cheque }
      else
        format.html { render :new }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cheques/1
  # PATCH/PUT /cheques/1.json
  def update
    respond_to do |format|
      if @cheque.update(cheque_params)
        format.html { redirect_to @cheque, notice: 'Cheque was successfully updated.' }
        format.json { render :show, status: :ok, location: @cheque }
      else
        format.html { render :edit }
        format.json { render json: @cheque.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cheques/1
  # DELETE /cheques/1.json
  def destroy
    @cheque.destroy
    respond_to do |format|
      format.html { redirect_to cheques_url, notice: 'Cheque was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cheque
      @cheque = Cheque.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cheque_params
      params.require(:cheque).permit(:name, :creation, :money)
    end

    def create_cheque_image(cheque_data)
      string_date = cheque_data[:creation].strftime("%B #{cheque_data[:creation].day.ordinalize}, %Y")
      money_parts = cheque_data[:money].to_s.split(".")
      string_money = money_parts[0].to_i.to_words + " dollars"
      if money_parts.count > 1
        string_money += " and " + money_parts[1].to_i.to_words + " cents" 
      end
      puts string_date
      puts string_money.split.map(&:capitalize)*' '

      cheque_image = Magick::ImageList.new("public/images/chequetemplate.png")
      name_text = Magick::Draw.new
      name_text.annotate(cheque_image, 445, 28, 105, 144, cheque_data[:name]) {
                    self.pointsize = 24
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      
      money_word_text = Magick::Draw.new
      money_word_text.annotate(cheque_image, 598, 28, 33, 168+15, string_money.split.map(&:capitalize)*' ') {
                    self.pointsize = 16
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      
      money_text = Magick::Draw.new
      money_text.annotate(cheque_image, 112, 33, 598+28, 120+25, cheque_data[:money].to_s) {
                    self.pointsize = 26
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      
      date_text = Magick::Draw.new
      date_text.annotate(cheque_image, 189, 22, 424, 88, string_date) {
                    self.pointsize = 17
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }
      cheque_image.write("public/images/" + cheque_data[:creation].strftime("%Y%m%d") +  @cheque[:id].to_s + ".png")
    end
end
