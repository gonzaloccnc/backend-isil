package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import pe.isil.app.domain.models.User;

import java.util.Optional;
import java.util.UUID;

public interface IUserRepo extends JpaRepository<User, String> {

    Optional<User> findByEmail(String email);
    Optional<User> findByDocId(String dni);
}
