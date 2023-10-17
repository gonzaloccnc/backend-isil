package pe.isil.app.controllers.user;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.dtos.MonoDto;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.models.UserProfile;
import pe.isil.app.domain.repos.IUserProfileRepo;
import pe.isil.app.domain.repos.IUserRepo;

@RestController
@RequestMapping("/user/me")
@RequiredArgsConstructor
public class ProfileController {

  private final IUserProfileRepo userProfileRepo;
  private final IUserRepo userRepo;

  @GetMapping("/{id}")
  @Transactional
  public ResponseEntity<?> getProfile(@PathVariable String id) {

    var profile = userProfileRepo.getProfile(id).orElse(null);

    if(profile == null) {
      return ResponseEntity.status(404).body(
        MonoDto.builder()
            .ok(false)
            .status(404)
            .message("Usuario no existe con id: " + id)
            .build()
      );
    }

    return ResponseEntity.ok(
        MonoDto.builder()
            .data(profile)
            .status(200)
            .ok(true)
            .build()
    );
  }

  @PatchMapping("/{id}")
  @Transactional
  public ResponseEntity<?> updateProfile(@PathVariable String id, @RequestBody User user) {
    var userDb = userRepo.findById(id).orElse(null);

    if(userDb == null) {
      return ResponseEntity.status(404).body(
          MonoDto.builder()
              .ok(false)
              .status(404)
              .message("Usuario no existe con id: " + id)
              .build()
      );
    }


     userDb.setFirstname(
         user.getFirstname() == null ? userDb.getFirstname() : user.getFirstname()
     );
     userDb.setSurnames(
         user.getSurnames() == null ? userDb.getSurnames() : user.getSurnames()
     );
     userDb.setAddress(
         user.getAddress() == null ? userDb.getAddress() : user.getAddress()
     );
     userDb.setEmail(
         user.getEmail() == null ? userDb.getEmail() : user.getEmail()
     );
     userDb.setPhone(
         user.getPhone() == null ? userDb.getPhone() : user.getPhone().isEmpty() ? null : user.getPhone()
     );
     userDb.setPhoto(
         user.getPhoto() == null ? userDb.getPhoto() : user.getPhoto()
     );

    var updatedUser = userRepo.save(userDb);
    var userProfile = userProfileRepo.getProfile(updatedUser.getIdUser());

    return ResponseEntity.ok(
        MonoDto.builder()
            .data(userProfile)
            .ok(true)
            .status(200)
            .build()
    );
  }
}
