package com.tradecopier.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.tradecopier.domains.MasterAccount;
@Repository
public interface MasterAccountRepository extends JpaRepository<MasterAccount,Long> {

}
