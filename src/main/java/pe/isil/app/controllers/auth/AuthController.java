package pe.isil.app.controllers.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.domain.dtos.AuthenticationDto;
import pe.isil.app.domain.dtos.ErrorDto;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.repos.IUserRepo;
import pe.isil.app.domain.request.AuthenticationRequest;
import pe.isil.app.domain.request.RegisterRequest;
import pe.isil.app.services.JwtService;

import java.time.LocalDate;
import java.util.Date;
import java.util.UUID;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {
  private final IUserRepo userRepo;
  private final PasswordEncoder passwordEncoder;
  private final JwtService jwtService;
  private final AuthenticationManager manager;

  @PostMapping("/register")
  ResponseEntity<AuthenticationDto> register(@RequestBody RegisterRequest request) {
        var emailAlreadyExist = userRepo.findByEmail(request.getEmail()).isPresent();
        var dniAlreadyExist = userRepo.findByDocId(request.getDocId()).isPresent();

        if (emailAlreadyExist) {
           return ResponseEntity.status(400).body(
               AuthenticationDto.builder()
                   .ok(false)
                   .message("El correo se encuentra registrado")
                   .build()
           );
        }

        if (dniAlreadyExist) {
          return ResponseEntity.status(400).body(
              AuthenticationDto.builder()
                  .ok(false)
                  .message("El DNI se encuentra registrado")
                  .build()
          );
        }

        var user = User.builder()
            .idUser(UUID.randomUUID().toString())
            .firstname(request.getFirstname())
            .surnames(request.getSurnames())
            .email(request.getEmail())
            .password(passwordEncoder.encode(request.getPassword()))
            .typeDoc(request.getTypeDoc())
            .docId(request.getDocId())
            .userType(3)
            .state(1)
            .registerDate(LocalDate.now())
            .build();

        userRepo.save(user);
        var jwtToken = jwtService.generateToken(user);

        return ResponseEntity.ok(
            AuthenticationDto
                .builder()
                .token(jwtToken)
                .ok(true)
                .build()
        );
    }

  @PostMapping("/login")
  ResponseEntity<AuthenticationDto> login(@RequestBody AuthenticationRequest request) {
    manager.authenticate(
      new UsernamePasswordAuthenticationToken(
        request.getEmail(),
        request.getPassword()
      )
    );

    var user = userRepo.findByEmail(request.getEmail()).orElseThrow();
    var jwtToken = jwtService.generateToken(user);

    return ResponseEntity.ok(
        AuthenticationDto
            .builder()
            .token(jwtToken)
            .ok(true)
            .build()
    );
  }

  @PostMapping("/logout")
  ResponseEntity<?> logout() {
    return ResponseEntity.ok().build();
  }

}
