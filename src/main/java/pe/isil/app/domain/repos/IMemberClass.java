package pe.isil.app.domain.repos;

import org.springframework.data.jpa.repository.Query;
import pe.isil.app.domain.models.MemberClass;

import java.util.List;

public interface IMemberClass extends IReadOnlyRepo<MemberClass, String> {
  @Query("SELECT mc FROM members_class mc WHERE mc.idClassroom = ?1")
  List<MemberClass> getMembers(String idClassroom);
}
