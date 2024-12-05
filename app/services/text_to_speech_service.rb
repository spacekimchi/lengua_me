class TextToSpeechService
  require 'aws-sdk-polly'
  require 'tempfile'

  def initialize(text)
    @text = text
    @polly = Aws::Polly::Client.new(region: 'us-east-1')
  end

  def synthesize_speech
    response = @polly.synthesize_speech({
      output_format: 'mp3',
      text: @text,
      voice_id: 'Joanna', # You can choose different voices
    })

    temp_file = Tempfile.new(['audio', '.mp3'], binmode: true)
    temp_file.write(response.audio_stream.read)
    temp_file.rewind
    temp_file
  end
end

