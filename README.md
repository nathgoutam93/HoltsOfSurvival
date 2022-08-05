# Holts Of Survival 🦊

A Real-Time strategy game, where you play as a chief, build and maintain your Village to grow. 

![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/91387097/182233748-812940d0-d1d0-4c0b-bab2-4927423f13a2.gif)

This project was created for the [Planetscale X Hashnode Hackathon](https://townhall.hashnode.com/planetscale-hackathon?source=hashnode_countdown).

The game usage Godot as game engine and node.js/express as API

Game Demo: [holtsofsurvival.netlify.app](https://holtsofsurvival.netlify.app/)

## Server setup ⚙
1. fork the project
2. clone the project
3. Navigate to the project directory `cd hashnode_pscale_hackathone/rest_api`
4. install dependencies with `npm install`
5. Run with `npm start`

## Godot project setup ⚙
> Download Godot from [godotengine.org](https://godotengine.org/download)
1. fork the project
2. clone the project
3. open Godot and Click on `Import`
4. Browse to the cloned directory and select `hashnode_pscale_hackathone/holts of survival`
5. click import and edit
6. Open `Auth.gd` file
7. Change `LOG_IN_URL` to `http://localhost:3000/api/signin`
8. Chnage `SIGN_UP_URL` to `http://localhost:3000/api/signup`
9. Make sure `SplashScreen.tscn` is set to main scene
10. Click on Play.

## Contributing ✨
Contributions are greatly appreciated.

## License 🛡
HoltsOfSurvival is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
