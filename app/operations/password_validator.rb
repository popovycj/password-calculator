require 'trailblazer/operation'

class PasswordValidator < Trailblazer::Operation
  step :validate_file_extension
  step :validate_file_content
  step :count_valid_passwords

  def validate_file_extension(ctx, file:, **)
    if file.present? && file.content_type == 'text/plain' && File.extname(file.original_filename) == '.txt'
      true
    else
      ctx[:error] = 'Please upload a valid text file'
      false
    end
  end

  def validate_file_content(ctx, file:, **)
    pattern = /^\S [0-9]-[0-9]: \S+$/
    if File.foreach(file.path).all? { |line| line.match?(pattern) }
      true
    else
      ctx[:error] = 'Invalid file format'
      false
    end
  end

  def count_valid_passwords(ctx, file:, **)
    valid_passwords = 0
    File.foreach(file.path) do |line|
      requirement, password = line.split(':').map(&:strip)
      char, char_range = requirement.split(' ')
      min, max = char_range.split('-').map(&:to_i)
      count = password.count(char)
      valid_passwords += 1 if (min..max).include?(count)
    end
    ctx[:result] = valid_passwords
  end
end
