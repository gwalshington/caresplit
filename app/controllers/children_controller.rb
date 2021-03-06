class ChildrenController < ApplicationController
  before_action :set_child, only: [:show, :edit, :update, :destroy]

  # GET /children
  # GET /children.json
  def index
    @children = current_user.children
  end

  # GET /children/1
  # GET /children/1.json
  def show
  end

  # GET /children/new
  def new
    @child = Child.new
  end

  def new_onboard
    puts params
  end

  def create_children_onboard
    puts params

    params['children'].each do |child|
      puts 'new child'
      puts child
      if child['first_name'] != ''
        child[:user_id] = current_user.id
        birthday = child[:birthday]
        date = Date.new(birthday["(1i)"].to_i, birthday["(2i)"].to_i, birthday["(3i)"].to_i)
        Child.create(first_name: child[:first_name], notes: child[:notes], user_id: current_user.id, gender_id: child[:gender_id][:id].to_i, birthday: date)
      end

    end

    respond_to do |format|
      if params['children'].length > 1
        #@invites = GroupInvite.where('email = ? OR phone = ?', current_user.email, current_user.phone)
        #@group = GroupUser.find_by(user_id: current_user.id)
        # if @invites.length > 0
        #   @invites.each do |invite|
        #     GroupUser.create(user_id: current_user.id, group_id: invite.group_id, invited_by: invite.user_id)
        #     invite.delete
        #   end
        #   format.html { redirect_to welcome_new_user_url }
        #   format.json { head :no_content }
        # else
          format.html { redirect_to welcome_new_user_url }
          format.json { head :no_content }
        #end
      else
        format.html { render new_child_onboard_url }
        format.json { render json: "Please put your child(ren)'s information.'", status: :unprocessable_entity }
      end
    end
  end

  # GET /children/1/edit
  def edit
  end

  # POST /children
  # POST /children.json
  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
        format.html { redirect_to children_url, notice: '' + @child.first_name + ' was successfully added.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /children/1
  # PATCH/PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        format.html { redirect_to children_url, notice: 'Your child\'s information was successfully updated.' }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    @child.destroy
    respond_to do |format|
      format.html { redirect_to children_url, notice: 'The child record was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.require(:child).permit(:first_name, :birthday, :notes, :user_id, :gender_id)
    end
end
