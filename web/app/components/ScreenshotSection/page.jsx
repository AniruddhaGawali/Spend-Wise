// "use client";
// import React, { useState, useEffect } from "react";
// import Slider from "../Slider/page";

// export const ScreenshotSection = () => {
//   const imageList = [
//     { url: "/product_img_4.jpg" },
//     { url: "/product_img_1.jpg" },
//     { url: "/product_img_3.jpg" },
//     { url: "/product_img_5.jpg" },
//     { url: "/product_img_6.jpg" },
//     { url: "/product_img_7.jpg" },
//   ];

  

//   return (
//     <div className="md:relative w-screen flex flex-col h-[900px] justify-center bg-slate-100 my-16 bg-[url('/comingsoon-img.jpg')] bg-cover bg-center">
//       <div className="backdrop-blur-sm bg-white/30 hover:backdrop-blur-lg h-full">
//       <h2 className="font-bold text-xl md:text-4xl mb-4 md:mt-10">Screenshots</h2>
//       <p className="mb-4 text-lg md:text-2xl">Browse through major features of App.</p>
//       <Slider
//         imageList={imageList}
//         width={300}
//         height={500}
//         loop={true}
//         autoPlay={true}
//         autoPlayInterval={3000}
//         showArrowControls={true}
//         showDotControls={true}
//         bgColor="bg-[url('/comingsoon1.jpg')]"
//         />
//         </div>
//     </div>
//   );
// };

"use client";
import React from "react";
import Slider from "../Slider/page";

export const ScreenshotSection = () => {
  const imageList = [
    { url: "/product_img_4.jpg" },
    { url: "/product_img_1.jpg" },
    { url: "/product_img_3.jpg" },
    { url: "/product_img_5.jpg" },
    { url: "/product_img_6.jpg" },
    { url: "/product_img_7.jpg" },
  ];

  return (
    <div className="md:relative w-screen flex flex-col h-[900px] justify-center bg-slate-100 my-16 md:bg-[url('/comingsoon-img.jpg')] bg-cover bg-center">
      <div className="md:backdrop-blur-sm md:bg-white/30  md:hover:backdrop-blur-lg h-full">
        <h2 className="font-bold text-2xl md:text-4xl mb-4 md:mt-10 md:text-white text-black p-5">
          Screenshots
        </h2>
        <p className="mb-4 text-base md:text-2xl md:text-white text-black p-5">
          Browse through major features of the App.
        </p>
        <Slider
          imageList={imageList}
          width={300}
          height={500}
          loop={true}
          autoPlay={true}
          autoPlayInterval={3000}
          showArrowControls={true}
          showDotControls={true}
          bgColor="bg-none"
        />
      </div>
    </div>
  );
};
