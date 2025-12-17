module Api
  module V1
    class VoiceRequestsController < ApplicationController
      def create
        vr = VoiceRequest.create!(voice_request_params)
        GenerateVoiceJob.perform_async(vr.id)
        render json: { id: vr.id, status: vr.status }, status: :accepted
      end

      def show
        vr = VoiceRequest.find(params[:id])
        render json: vr
      end

      def index
        render json: VoiceRequest.order(created_at: :desc).limit(20)
      end

      private

      def voice_request_params
        params.require(:voice_request).permit(:input_text)
      end
    end
  end
end
