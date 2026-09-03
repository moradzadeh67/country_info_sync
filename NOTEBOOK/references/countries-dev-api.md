# CountryInfo Sync — مرجع جلسه ۲۰۲۶-۰۹-۰۳

این جلسه دو درس کلیدی ثبت کرد:
1. **تأیید داده قبل از بازنویسی:** قبل از هر بازنویسی مدل، با `curl` و `python` ساختار داده واقعی (`/tmp/countries_list.json`) بررسی شد. `countries.dev` بدون key ۲۵۰ کشور واقعی می‌دهد.
2. **سازگاری مدل با API جدید:** `capital` از `List<String>` به `String?`، `languages` از `Map` به `List<String>`، `currencies` از `Map` به `List<String>`، `callingCode` از محاسبه `idd.root+suffixes` به `callingCodes.first` تغییر کرد.
