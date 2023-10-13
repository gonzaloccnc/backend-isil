package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.query.Procedure;
import pe.isil.app.domain.models.UserProfile;

import java.util.Optional;

public interface IUserProfileRepo extends IReadOnlyRepo<UserProfile, String> {

  @Procedure
  Optional<UserProfile> getProfile(String id);

}
