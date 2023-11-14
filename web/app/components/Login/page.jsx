import React from 'react'

export const LogIn = ()=> {
  return (
    <div className="min-h-screen flex items-center justify-center">
    <div className="bg-white p-8 shadow-md rounded-md max-w-md w-full">
      <h2 className="text-2xl font-bold mb-6 text-[var(--gradient-end-color)]">Login</h2>
      <form>
        <div className="mb-4">
          <label htmlFor="username" className="block text-gray-700 text-sm font-bold mb-2">
            Username
          </label>
          <input
            type="text"
            id="username"
            name="username"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-[var(--gradient-start-color)]"
          />
        </div>
        <div className="mb-4">
          <label htmlFor="password" className="block text-gray-700 text-sm font-bold mb-2">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:border-[var(--gradient-start-color)]"
          />
        </div>
        <div className="mb-4 flex items-center">
          <input
            type="checkbox"
            id="rememberMe"
            name="rememberMe"
            className="mr-2"
          />
          <label htmlFor="rememberMe" className="text-sm text-gray-600">
            Remember Me
          </label>
        </div>
        <div className="mb-4">
          <a href="/forgot-password" className="text-[var(--gradient-start-color)] text-sm hover:underline">
            Forgot Password?
          </a>
        </div>
        <button
          type="submit"
          className="w-full bg-[var(--gradient-start-color)] text-white py-2 rounded-md hover:bg-[var(--gradient-end-color)] focus:outline-none"
        >
          Log In
        </button>
      </form>
    </div>
  </div>
  )
}
