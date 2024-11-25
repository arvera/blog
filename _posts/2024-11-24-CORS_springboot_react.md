---
layout: single
title: CORS in Spring Boot with React
date: 2024-11-24
tag: springboot react cors
---

I have been doing a lot of learning in react. I have a small spring boot application for an application that has a server side frontend, and I wanted to add a react storefront.

I got everything running in my computer, where Spring boot is running inside of Eclipse, and React is runing with the default React native server, the one that comes with your tutorial application when you do `npx create-react-app afp-react-app`.

By default spring boot apps run in port 8080 and the react server runs in 3000 and this is effectively a Cross-Origin Resource Sharing scenario, CORS for short. If you come from my world where Sever side application is all you know or if you are starting from Scratch as a Full Stack Developer, CORS problems are common and something that needs to be understood and not be thought as a problem for later.

As I was developing my React application I encounter this CORS problem when trying to get my Authentication and Bearer scenario. In my case, using postman against the backend spring boot application worked without proble. When calling POST /api/auth/signin it would return me the bearer token and then using that token and calling api/admin/users/get it would break

Here is the signin call from postman:

```
POST /api/auth/signin HTTP/1.1
Host: localhost:8080
Content-Type: application/json
Cookie: JSESSIONID=5952F39157BBB77A4B813F73F37015B4
Content-Length: 60

{
    "username": "admin",
    "password": "admin"
}

```

The second call to confirm that my spring boot app was working using postman looked like:

```
GET /api/admin/users/get HTTP/1.1
Host: localhost:8080
Authorization: Bearer eyJhbGdsadsaIUzUxMiJ9.eyJzdWIiOiJasdsa33sadnJvbGVzIjpbIlJPTESKJWNyt4iLCJST0xFX1NVUEVSQURNSU5fVUkiLCJST0xFX1RFTExFUiJdLCJpYXQiOEXHyzI0NTE0MTYsImV4cCI6MTczMjQ1MASD4Nn0.48zzrDSAADG4sEqI5BO7UtVd_otlmEAi6ZWADS9KGRRSaASxxjYpxsVi28AhLP7QogF1_sIfp435sFxQl8iuiWVOQ
Cookie: JSESSIONID=E2F5F4BBC871D33B368BC44C1E977BEF
```

My Springboot application appeared to be correctly configured with all of this setup, so I went ahead and started working on my React app.

I will skip some of the details of the react code as my goal is not to focus on the working of the react app, just pretend I have a login screen that when filled correctly and the user clicks on the Login button it calls my export thunk function:

```
export const signinThunk = createAsyncThunk('user/signin',
  (postData) => {
    // FETCH
    return fetch(backendURL+'/api/auth/signin',
    {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      rejectUnauthorized: false,//add when working with https sites
      requestCert: false,//add when working with https sites
      agent: false,//add when working with https sites
      body: JSON.stringify(postData)
    })
    .then(rest => rest.json())
    .then(data => data)
    },
    {
      condition(arg,thunkApi) {
        const userNetworkStatus = selectUserNetworkStatus(thunkApi.getState())
        if (userNetworkStatus !== 'idle'){
          return false;
        }
    }
```

As you can see I have added already some extra options to my fetch call that supposedly were going to help me when working https calls (I originally had my spring boot application running with HTTPS and a self signed certificate) while debugging I removed the HTTPS part to simply the scenario. This seemed to work okay for the api/auth/signin part, and with my original configuration but when I went to do the second part to the /api/admin/users/get I would get a CORS error in the javascript console of the browser, like:

```
/admin/users:1 Access to fetch at 'http://localhost:8080/api/admin/users/get' from origin 'http://localhost:3000' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: Redirect is not allowed for a preflight request.
```

Doing a lot of research I came to several post, one wold show about adding an annotation to the class to allow the frontend domain to pass through: [https://spring.io/guides/gs/rest-service-cors](https://spring.io/guides/gs/rest-service-cors), adding an annotation was not an option for me because XYZ reasons, so I then went with the adding a global config for certain routes, as describe in the same article under [Global CORS Configuration](https://spring.io/guides/gs/rest-service-cors#global-cors-configuration), this was also very similar implementation to the one that I found in stack overflow where it talks about adding a [@Bean to modify the registry configuration](https://stackoverflow.com/questions/60836302/react-js-and-spring-boot-cors-policy/71712852)

Showing me to change the Spring Boot code in a way that would modify the registry ad add the mappings:

```
     @Override
    public void addCorsMappings(CorsRegistry registry) {
         registry
         .addMapping("/**")
         //.addMapping("/api/**")
         //.allowedOrigins("http://localhost:3000/")
         .allowedOriginPatterns(CorsConfiguration.ALL)
         .allowCredentials(false)
         .allowedOriginPatterns(CorsConfiguration.ALL)
         .allowedHeaders(CorsConfiguration.ALL);

    }
```

As you can see I tried a few different ways and I wasn't able to get it to work, I then continue reading and trying things for hours/days until I decided to try a different approach. This different approach creates a method with the @Bean annotation, and using the CorsConfiguration class it sets the conditions. We call this method from the already existing securityFilterChain method, I like this approach as it keeps all my configuration in one class. Below is the sample.

```
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    ...other code..

    @Bean
	CorsConfigurationSource corsConfigurationSource() {
	    CorsConfiguration configuration = new CorsConfiguration();
	    configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000"));
	    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
	    configuration.setAllowedHeaders(Arrays.asList("Content-Type", "Authorization"));
	    configuration.setAllowCredentials(true);

	    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
	    source.registerCorsConfiguration("/api/**", configuration);
	    return source;
	}

    @Bean
	protected SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

		http
			.cors(cors -> cors.configurationSource(corsConfigurationSource()))
			.formLogin( (form) -> form
        		.loginPage("/login").permitAll()
        		.loginProcessingUrl("/login")
        		.defaultSuccessUrl("/?success").permitAll()
        		.failureUrl("/login?error").permitAll()
        		)
			.authorizeHttpRequests( (request) -> request
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/debug")).permitAll()
			    //.requestMatchers(AntPathRequestMatcher.antMatcher("/**")).permitAll() // to disable security
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/")).permitAll()
			    .requestMatchers(AntPathRequestMatcher.antMatcher(HttpMethod.POST,"/logout")).permitAll()
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/home")).permitAll()
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/public/**")).permitAll()
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/error")).permitAll()
			    .requestMatchers(AntPathRequestMatcher.antMatcher("/custom-logout")).permitAll()

            ...other rules...

            .csrf((csrf) -> csrf
					.ignoringRequestMatchers("/actuator/**")
					.ignoringRequestMatchers("/api/**")
				)

            ...other code...

		http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
```

This is what did the trick for me, after this I stopped having any troubles with CORS between REACT and Spring boot. There sure are others solutions out there like setting a proxy in react, but I don't like that approach as it should not be carried into production as it could pose a security risk. The approach documented here should be made configurable and allow to add more AllowedOrigins from the applications.property file. For now this works for my small sample and I was happy with the results.

I wanted to document this steps as I found people can trip over this same problem and end up with an approach that doesn't seem to work for me.
