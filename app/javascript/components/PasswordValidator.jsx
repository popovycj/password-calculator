import React, { useState } from 'react';
import axios from 'axios';
import { motion } from 'framer-motion';

function PasswordValidator() {
  const [file, setFile] = useState(null);
  const [error, setError] = useState(null);
  const [result, setResult] = useState(null);
  const [showForm, setShowForm] = useState(false);

  const handleFileChange = (event) => {
    setFile(event.target.files[0]);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    if (!file) {
      setError('Please select a file to validate.');
      return;
    }

    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await axios.post('/api/v1/passwords/count', formData, { headers: {
        'Content-Type': 'multipart/form-data',
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content }
      });
      setResult(response.data.result);
      setError(null);
    } catch (error) {
      setResult(null);
      setError(error.response.data.error);
    }
  };

  return (
    <div className="container">
      <h1 className="text-center mt-5">Password Validator</h1>
      <div className="d-flex justify-content-center">
        <motion.button
          className="btn btn-primary mb-3"
          onClick={() => setShowForm(!showForm)}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          {showForm ? 'Hide file uploading' : 'Upload File'}
        </motion.button>
      </div>

      <motion.div
        className="accordion"
        animate={{ height: showForm ? 'auto' : 0 }}
        transition={{ duration: 0.5 }}
      >
        <form onSubmit={handleSubmit} class="pb-3">
          <div className="form-group">
            <label htmlFor="fileInput">Select a file to validate:</label>
            <input
              type="file"
              className="form-control-file"
              id="fileInput"
              onChange={handleFileChange}
            />
            {error && (
              <motion.div
                className="text-danger mb-2"
                animate={{ y: 5, opacity: 1 }}
                transition={{ duration: 0.5 }}
              >
                {error}
              </motion.div>
            )}
          </div>

          <button type="submit" className="btn btn-primary">
            Validate Passwords
          </button>
        </form>

        {result && (
          <div className="alert alert-success">
            {result} valid passwords found!
          </div>
        )}
      </motion.div>


      <div className="card">
        <div className="card-body">
          <h5 className="card-title">Instruction</h5>
          <p className="card-text">
            Please upload a valid text file with one password per line. Each
            line should have the format:
          </p>
          <code className="card-text">
            {"[letter] [number]-[number]: [password]"}
          </code>
          <p className="card-text">
            For example: <code className="card-text">a 1-3: abcde</code>
          </p>
          <p className="card-text fw-bolder">
            Note: The password is valid if the letter appears between the two numbers
            (inclusive) of times in the password.
          </p>
        </div>
      </div>
    </div>
  );
}

export default PasswordValidator;
