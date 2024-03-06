class JobsController < ApplicationController
  before_action :set_job, only: %i[ edit update destroy ]

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all.order(created_at: :desc)
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@job,
                                                 partial: "jobs/form",
                                                 locals: {job: @job})
      end
    end
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_job',
                                partial: "jobs/form",
                                locals: {job: Job.new}),
            turbo_stream.prepend('jobs',
                                partial: "jobs/job",
                                locals: {job: @job}),
          ]
        end
        format.html { redirect_to @job, notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('new_job',
                                                    partial: "jobs/form",
                                                    locals: {job: @job})
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@job,
                                                   partial: "jobs/job",
                                                   locals: {job: @job})
        end
        format.html { redirect_to @job, notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@job,
                                                   partial: "jobs/form",
                                                   locals: {job: @job})
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@job)
      end
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :description)
    end
end
