package com.tradecopier.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface ChildAccountRepository extends JpaRepository<ChildAccountRepository,Long> {

}
