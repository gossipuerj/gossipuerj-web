class EnumMappers {
  const EnumMappers._();

  static const genderLabelByApi = <String, String>{
    "MALE": "Masculino",
    "FEMALE": "Feminino",
    "NON_BINARY": "Não-binário",
    "OTHER": "Outro",
    "PREFER_NOT_TO_SAY": "Prefiro não informar",
  };

  static const orientationLabelByApi = <String, String>{
    "STRAIGHT": "Heterossexual",
    "GAY": "Homossexual",
    "LESBIAN": "Lésbica",
    "BISEXUAL": "Bissexual",
    "PANSEXUAL": "Pansexual",
    "OTHER": "Outro",
  };

  static const genderApiByLabel = <String, String>{
    "Masculino": "MALE",
    "Feminino": "FEMALE",
    "Não-binário": "NON_BINARY",
    "Outro": "OTHER",
    "Prefiro não informar": "PREFER_NOT_TO_SAY",
    "Não informado": "PREFER_NOT_TO_SAY",
  };

  static const orientationApiByLabel = <String, String>{
    "Heterossexual": "STRAIGHT",
    "Homossexual": "GAY",
    "Lésbica": "LESBIAN",
    "Bissexual": "BISEXUAL",
    "Pansexual": "PANSEXUAL",
    "Outro": "OTHER",
    "Não informado": "OTHER",
  };

  static String? genderLabel(String? apiValue) =>
      apiValue == null ? null : genderLabelByApi[apiValue] ?? apiValue;

  static String? orientationLabel(String? apiValue) =>
      apiValue == null ? null : orientationLabelByApi[apiValue] ?? apiValue;

  static String? genderApi(String? label) =>
      label == null ? null : genderApiByLabel[label] ?? label;

  static String? orientationApi(String? label) =>
      label == null ? null : orientationApiByLabel[label] ?? label;
}
