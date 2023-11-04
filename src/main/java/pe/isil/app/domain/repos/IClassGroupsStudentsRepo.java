package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.isil.app.domain.models.ClassGroupsStudents;
import pe.isil.app.domain.models.KeyClass;

public interface IClassGroupsStudentsRepo extends JpaRepository<ClassGroupsStudents, KeyClass> {




}
