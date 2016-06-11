require 'to_words'
require 'RMagick'

class ChequesController < ApplicationController
  before_action :set_cheque, only: [:show, :destroy]

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

    # bad validation here, but I don't understand how to do it properly
    if valid_money?(@cheque)
      @cheque.save
      create_cheque_image(@cheque)
      redirect_to @cheque, :notice => 'Cheque was successfully created.'
    else
      puts "error"
      redirect_to @cheque, :notice => 'Amount must be between 0.01 and 9999.99!'
    end
  end


# NOT USED
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


    # really stupid validation but it werks
    def valid_money?(cheque_data)
      money_parts = cheque_data[:money].to_s.split(".") # get the dollars and cents
      dollars = money_parts[0].to_i
      if money_parts.count > 1 # if we have any cents, get those
        cents = money_parts[1].to_i
      end
      if (cents.to_s.size > 2)
        puts "2many decimals"
        return false
      end 
      if (dollars+cents <= 0) or (dollars > 9999)
        puts "over 9000!"
        return false
      end
      return true
    end 

    # big messy function to draw on the image
    def create_cheque_image(cheque_data)
      string_date = cheque_data[:creation].strftime("%B #{cheque_data[:creation].day.ordinalize}, %Y") # convert our date into words!
      money_parts = cheque_data[:money].to_s.split(".") # get the dollars and cents
      string_money = money_parts[0].to_i.to_words + " dollars" # dollars as words
      name_to_write = cheque_data[:name]
      # if cheque_data[:name] == ""
      #   name_to_write = "No Name"
      # end
      if money_parts.count > 1 # if we have any cents, get those
        string_money += " and " + money_parts[1].to_i.to_words + " cents" 
      end
      cheque_image = Magick::ImageList.new("public/images/chequetemplate.png") # load up template image

      # draws the name entered
      name_text = Magick::Draw.new
      name_text.annotate(cheque_image, 445, 28, 105, 144, name_to_write) {
                    self.pointsize = 24
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      

      # draws the money as words
      money_word_text = Magick::Draw.new
      money_word_text.annotate(cheque_image, 598, 28, 33, 168+15, string_money.split.map(&:capitalize)*' ') {
                    self.pointsize = 16
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      

      # draws the money as a number
      money_text = Magick::Draw.new
      money_text.annotate(cheque_image, 112, 33, 598+22, 120+25, '%.2f' % cheque_data[:money].to_s) {
                    self.pointsize = 26
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }      

      # finally draw the date
      date_text = Magick::Draw.new
      date_text.annotate(cheque_image, 189, 22, 424, 88, string_date) {
                    self.pointsize = 17
                    self.stroke = 'transparent'
                    self.fill = '#000'
                    self.gravity = Magick::ForgetGravity
                        }
      # save the image
      cheque_image.write("public/images/" + cheque_data[:creation].strftime("%Y%m%d") +  @cheque[:id].to_s + ".png")
    end
end
