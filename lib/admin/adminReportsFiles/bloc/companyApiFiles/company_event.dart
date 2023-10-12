part of 'company_bloc.dart';

abstract class CompanyEvent {
  const CompanyEvent();
}

class FetchCompanies extends CompanyEvent {
  final String corporateId;

  const FetchCompanies(this.corporateId);
}
