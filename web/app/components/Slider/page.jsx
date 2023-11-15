"use client"
import React from 'react';
import { useState,  useEffect } from 'react';
import Image from 'next/image';

export default function Slider(props) {
    const Slider = ({
        imageList = props.imageList,
        width = props.width,
        height = props. height,
        loop = true,
        autoPlay = true,
        autoPlayInterval = 3000,
        showArrowControls = true,
        showDotControls = true,
        bgColor = "none",
      }) => {
        let [active, setActive] = useState(0);
    
        const setPreviousImage = () => {
          if (active !== 0) {
            setActive((active -= 1));
          } else {
            if (loop) {
              setActive((active = imageList.length - 1));
            }
          }
        };
    
        const setNextImage = () => {
          if (active !== imageList.length - 1) {
            setActive((active += 1));
          } else {
            if (loop) {
              setActive((active = 0));
            }
          }
        };
    
        const leftClickHandle = () => {
          setPreviousImage();
        };
    
        const rightClickHandle = () => {
          setNextImage();
        };
    
        const dotClickHandler = (e) => {
          const dotNum = e.target.getAttribute("data-key");
          setActive((active = parseInt(dotNum)));
        };
    
        useEffect(() => {
          if (autoPlay) {
            let autoSlider = setInterval(setNextImage, autoPlayInterval);
            return () => clearInterval(autoSlider);
          }
        }, [active]);
    
        return (
          <div className={`sm:relative ${bgColor}`}>
            {showArrowControls && (
              <>
                <div
                  className="sm:absolute hidden w-20 h-20 left-20 top-1/2 transform -translate-y-1/2 cursor-pointer rounded-full bg-slate-300 sm:flex items-center justify-center ease-in-out duration-150"
                  onClick={leftClickHandle}
                >
                  &lt;
                </div>
                <div
                  className="sm:absolute hidden w-20 h-20 right-20 top-1/2 transform -translate-y-1/2 cursor-pointer rounded-full bg-slate-300 sm:flex items-center justify-center ease-in-out duration-150"
                  onClick={rightClickHandle}
                >
                  &gt;
                </div>
              </>
            )}
            {showDotControls && (
              <div className="sm:absolute  -bottom-8 left-1/2 transform -translate-x-1/2">
                {imageList.map((el, index) => (
                  <div
                    key={index}
                    className={`w-4 h-4 bg-gray-400 rounded-full inline-block mx-1 md:mx-2 ${
                      index === active ? "bg-pink-700" : ""
                    }`}
                    data-key={index}
                    onClick={dotClickHandler}
                  />
                ))}
              </div>
            )}
            <div className="flex justify-center items-center h-full">
            <Image
              src={imageList[active].url}
              width={width}
              height={height}
              alt="image"
              className="bg-contain rounded-3xl m-1 object-cover"
            />
            </div>
          </div>
        );
      };
  return (
    <> <Slider/></>
  )
}
