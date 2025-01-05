package com.dicore.fatura_yonetim_sistemi.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // Handle EntityNotFoundException
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ApiException> handleEntityNotFoundException(EntityNotFoundException ex) {
        ApiException apiException = new ApiException(
                ex.getMessage(),
                ex.getStatus(),
                ZonedDateTime.now()
        );
        return new ResponseEntity<>(apiException, ex.getStatus());
    }

    // Handle InvalidPaymentException
    @ExceptionHandler(InvalidPaymentException.class)
    public ResponseEntity<ApiException> handleInvalidPaymentException(InvalidPaymentException ex) {
        ApiException apiException = new ApiException(
                ex.getMessage(),
                ex.getStatus(),
                ZonedDateTime.now()
        );
        return new ResponseEntity<>(apiException, ex.getStatus());
    }

    // Handle EntityAlreadyExistsException
    @ExceptionHandler(EntityAlreadyExistsException.class)
    public ResponseEntity<ApiException> handleEntityAlreadyExistsException(EntityAlreadyExistsException ex) {
        ApiException apiException = new ApiException(
                ex.getMessage(),
                ex.getStatus(),
                ZonedDateTime.now()
        );
        return new ResponseEntity<>(apiException, ex.getStatus());
    }

    // Handle MethodArgumentNotValidException
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        for (FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }

    // Handle General Exceptions
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiException> handleGeneralException(Exception ex) {
        ApiException apiException = new ApiException(
                "An unexpected error occurred.",
                HttpStatus.INTERNAL_SERVER_ERROR,
                ZonedDateTime.now(ZoneId.of("Z"))
        );
        return new ResponseEntity<>(apiException, HttpStatus.INTERNAL_SERVER_ERROR);
    }

}
