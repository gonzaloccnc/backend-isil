package pe.isil.app.domain.repos;


import org.springframework.data.jpa.repository.JpaRepository;

import pe.isil.app.domain.models.GroupsClass;

public interface IGroupsEvaluationsRepo extends JpaRepository<GroupsClass, Integer> {


}
