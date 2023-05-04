require 'rails_helper'

RSpec.describe PasswordValidator do
  describe '#validate_file_extension' do
    context 'when file is present and is a valid text file' do
      let(:file) do
        file_content = ''
        file = Tempfile.new(['valid_text_file', '.txt'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'valid_text_file.txt', type: 'text/plain')
      end
      let(:ctx) { { file: file } }

      it 'does not include "Please upload a valid text file" message' do
        result = described_class.(ctx)
        expect(result[:error]).not_to include('Please upload a valid text file')
      end
    end

    context 'when file is not present' do
      let(:ctx) { { file: nil } }

      it 'sets an error message in the context' do
        result = described_class.(ctx)
        expect(result).to be_failure
        expect(result[:error]).to eq('Please upload a valid text file')
      end
    end

    context 'when file is present but is not a valid text file' do
      let(:file) do
        file_content = "a 1-3: abc\nb 2-4: bbcd\nc 3-5: cccdecc\n"
        file = Tempfile.new(['invalid_file', '.pdf'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'invalid_file.pdf', type: 'application/pdf')
      end
      let(:ctx) { { file: file } }

      it 'sets an error message in the context' do
        result = described_class.(ctx)
        expect(result).to be_failure
        expect(result[:error]).to eq('Please upload a valid text file')
      end
    end
  end

  describe '#validate_file_content' do
    context 'when file content is valid' do
      let(:file) do
        file_content = "a 1-3: abc\nb 2-4: bbcd\nc 3-5: cccdecc\n"
        file = Tempfile.new(['valid_text_file', '.txt'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'valid_text_file.txt', type: 'text/plain')
      end
      let(:ctx) { { file: file } }

      it 'returns true' do
        result = described_class.(ctx)
        expect(result).to be_success
      end
    end

    context 'when file content is invalid' do
      let(:file) do
        file_content = "1-3 a: abc\n2-4 b: bcd\ninvalid content\n"
        file = Tempfile.new(['invalid_text_file', '.txt'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'invalid_text_file.txt', type: 'text/plain')
      end
      let(:ctx) { { file: file } }

      it 'sets an error message in the context' do
        result = described_class.(ctx)
        expect(result).to be_failure
        expect(result[:error]).to eq('Invalid file format')
      end
    end
  end

  describe '#count_valid_passwords' do
    context 'when file contains valid passwords' do
      let(:file) do
        file_content = "a 1-3: abc\nb 2-4: bbbcd\nc 3-5: cccdecc\n"
        file = Tempfile.new(['valid_text_file', '.txt'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'valid_text_file.txt', type: 'text/plain')
      end
      let(:ctx) { { file: file } }

      it 'sets the number of valid passwords in the context' do
        result = described_class.(ctx)
        expect(result).to be_success
        expect(result[:result]).to eq(3)
      end
    end

    context 'when file contains invalid passwords' do
      let(:file) do
        file_content = "a 2-3: abc\nb 2-4: bcd\nc 3-5: cde\nd 4-6: defg\n"
        file = Tempfile.new(['invalid_text_file', '.txt'])
        file.write(file_content)
        file.rewind
        ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: 'invalid_text_file.txt', type: 'text/plain')
      end
      let(:ctx) { { file: file } }

      it 'sets the number of valid passwords in the context' do
        result = described_class.(ctx)
        expect(result).to be_success
        expect(result[:result]).to eq(0)
      end
    end
  end
end
