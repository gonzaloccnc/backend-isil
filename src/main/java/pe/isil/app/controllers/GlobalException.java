package pe.isil.app.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.http.HttpServletRequest;
import org.hibernate.exception.ConstraintViolationException;
import org.hibernate.id.IdentifierGenerationException;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;
import pe.isil.app.domain.dtos.ErrorDto;

@RestControllerAdvice
public class GlobalException {

  @ExceptionHandler(NoHandlerFoundException.class)
  public ResponseEntity<ErrorDto> notFound(HttpServletRequest req, NoHandlerFoundException ex) {
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
        ErrorDto
            .builder()
            .message(HttpStatus.NOT_FOUND.getReasonPhrase())
            .status(HttpStatus.NOT_FOUND.value())
            .error(ex.getMessage())
            .url(req.getRequestURI())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(JsonProcessingException.class)
  ResponseEntity<ErrorDto> handleParseJson(HttpServletRequest req, JsonProcessingException ex) {
    return ResponseEntity.badRequest().body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .error(HttpStatus.BAD_REQUEST.getReasonPhrase())
            .message(ex.getOriginalMessage())
            .status(HttpStatus.BAD_REQUEST.value())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(IllegalArgumentException.class)
  ResponseEntity<ErrorDto> handleConverterString(HttpServletRequest req, IllegalArgumentException ex) {
    return ResponseEntity.badRequest().body(
        ErrorDto.builder()
            .url(req.getRequestURI())
            .error(HttpStatus.BAD_REQUEST.getReasonPhrase())
            .message(ex.getMessage())
            .status(HttpStatus.BAD_REQUEST.value())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(ConstraintViolationException.class)
  ResponseEntity<ErrorDto> handleViolateConstraint(HttpServletRequest req, ConstraintViolationException ex){
    return ResponseEntity.badRequest().body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .status(HttpStatus.BAD_REQUEST.value())
            .message(ex.getSQLException().getMessage())
            .error(HttpStatus.BAD_REQUEST.getReasonPhrase())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(IdentifierGenerationException.class)
  ResponseEntity<ErrorDto> handleIdentifierGeneration(HttpServletRequest req, IdentifierGenerationException ex) {
    return ResponseEntity.badRequest().body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .status(HttpStatus.BAD_REQUEST.value())
            .message(ex.getMessage())
            .error(HttpStatus.BAD_REQUEST.getReasonPhrase())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(UsernameNotFoundException.class)
  ResponseEntity<ErrorDto> userNotFoundHandler(HttpServletRequest req, UsernameNotFoundException ex) {
    return ResponseEntity.status(404).body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .status(HttpStatus.NOT_FOUND.value())
            .message(ex.getMessage())
            .error(HttpStatus.NOT_FOUND.getReasonPhrase())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(AuthenticationException.class)
  ResponseEntity<?> authenticationHandler(HttpServletRequest req, AuthenticationException ex) {
    return ResponseEntity.status(401).body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .status(HttpStatus.UNAUTHORIZED.value())
            .message(ex.getMessage())
            .error(HttpStatus.UNAUTHORIZED.getReasonPhrase())
            .ok(false)
            .build()
    );
  }

  @ExceptionHandler(JwtException.class)
  ResponseEntity<?> jwtHandler(HttpServletRequest req, JwtException ex) {
    return ResponseEntity.status(401).body(
        ErrorDto
            .builder()
            .url(req.getRequestURI())
            .status(HttpStatus.UNAUTHORIZED.value())
            .message(ex.getMessage())
            .error(HttpStatus.UNAUTHORIZED.getReasonPhrase())
            .ok(false)
            .build()
    );
  }
}
