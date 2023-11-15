import React from "react";
import { Navbar } from "./components/Navbar/page";
import {HeroSection} from "./components/HeroSection/page";
import {PromotionSection} from "./components/PromotionSection/page";
import {ScreenshotSection} from "./components/ScreenshotSection/page";
import {Footer} from "./components/Footer/page";

export default function Home() {
  return (
    <>
     <Navbar/>
    <div className="overflow-y-auto overflow-x-hidden md:mt-auto mt-20">
     <HeroSection/>
      <ScreenshotSection/>
     <PromotionSection/>
     <span className="text-center text-gray-500 text-xs">
      <Footer />
      </span>
    </div>
    </>
  );
}
