package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;

import pe.isil.app.domain.models.User;

import java.util.Optional;

public interface IUserRepo extends JpaRepository<User, String> {

    Optional<User> findByEmail(String email);
    Optional<User> findByDocId(String dni);
}
