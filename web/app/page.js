import React from "react";
import { Navbar } from "./components/Navbar/page";
import {HeroSection} from "./components/HeroSection/page";
import {PromotionSection} from "./components/PromotionSection/page";
import {ScreenshotSection} from "./components/ScreenshotSection/page";

export default function Home() {
  return (
    <>
     <Navbar/>
     <HeroSection/>
      <ScreenshotSection/>
     <PromotionSection/>
    </>
  );
}
